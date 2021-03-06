#include "httpclient.h"
#include "strlib.h"
#include <stdio.h>
#include <stdlib.h>


HTTPRequest::HTTPRequest()
{
    //m_szRequestStr.reserve(HTTP_HEADER_MAX_SIZE + HTTP_CONTENT_MAX_SIZE);
    //m_szContent.reserve(HTTP_CONTENT_MAX_SIZE);
    Clear();
}

HTTPRequest::~HTTPRequest()
{

}

void HTTPRequest::setVersion(const char *szVersion)
{
    m_szVersion = szVersion;
}

void HTTPRequest::setMethod(const char *szMethod)
{
    m_szMethod = szMethod;
}

void HTTPRequest::setURI(const char *szURI)
{
    m_szURI = szURI;
}

void HTTPRequest::setHost(const char *szHost)
{
    addHeaderItem("Host",szHost);
}

void HTTPRequest::setContentType(const char *szType)
{
    addHeaderItem("Content-Type",szType);
}

void HTTPRequest::addHeaderItem(const char * szItemName, const char * itemData)
{

    m_szHeaderName[m_iHeaderItemCount] = szItemName;
    m_szHeaderData[m_iHeaderItemCount] = itemData;
    m_iHeaderItemCount++;
}

void HTTPRequest::addContent(const char *content)
{
    m_szContent += content;
    m_iContentLen += strlen(content);
}

void HTTPRequest::setContentLen(unsigned int iLen)
{
    m_iContentLen = iLen;
}

void HTTPRequest::setHttpRequestStr(const char *request)
{
    if(strlen(request)>(HTTP_HEADER_MAX_SIZE+HTTP_CONTENT_MAX_SIZE))
        return;
    m_szRequestStr = request;

    m_bRequestStringPrepared = true;
}

const char * HTTPRequest::requestString()
{
    if (false == m_bRequestStringPrepared)
    {
        prepareRequestStr();
    }
    return m_szRequestStr.c_str();
}

void HTTPRequest::prepareRequestStr()
{

    m_szRequestStr = m_szMethod;
    m_szRequestStr += " ";
    m_szRequestStr += m_szURI;
    m_szRequestStr += " ";
    m_szRequestStr += m_szVersion;
    m_szRequestStr += "\r\n";

    if(m_iContentLen)
    {
        m_szRequestStr += "Content-Length: ";
        char len[32];
        sprintf(len,"%d",m_iContentLen);
        m_szRequestStr += len;
        m_szRequestStr += "\r\n";
    }

    //Add the header items

    for(int i = 0; i< m_iHeaderItemCount; i++)
    {
        m_szRequestStr += m_szHeaderName[i];
        m_szRequestStr += ": ";
        m_szRequestStr += m_szHeaderData[i];
        m_szRequestStr += "\r\n";
    }

    //End the header partition with double CRLF
    m_szRequestStr += "\r\n";

    //Add the content
    m_szRequestStr += m_szContent;


    m_bRequestStringPrepared = true;

}

void HTTPRequest::Clear()
{

   m_bRequestStringPrepared = false;
   m_iHeaderItemCount = 0;
   m_iContentLen = 0;
   m_szContent.clear();
}

HTTPResponse::HTTPResponse()
{
    //m_szResponseStr.reserve(HTTP_HEADER_MAX_SIZE + HTTP_CONTENT_MAX_SIZE);
   //m_szContent.reserve(HTTP_CONTENT_MAX_SIZE);
    Clear();
}

HTTPResponse::~HTTPResponse()
{

}

const char * HTTPResponse::getHttpResponseStr()
{
    return m_szResponseStr.c_str();
}

void HTTPResponse::setHttpResponseStr(const char *responseStr)
{
    m_szResponseStr = responseStr;
}

unsigned int HTTPResponse::contentLen()
{
    return m_iContentLen;
}

void HTTPResponse::parseResponseStr()
{

    int iHead = 0;

    //Determine if the response contains HTTP header
    bool  bContainsHeader = false;


    char dummy[256];
    memcpy(dummy,m_szResponseStr.c_str(),256);
    dummy[63] = 0;

    if(-1 != strlib::strLocate(dummy,"HTTP/1."))
    {
        bContainsHeader = true;
    }

    if(true == bContainsHeader)
    {
        //Status partition
        iHead += strlib::extractStr(&m_szResponseStr[iHead],' ',m_szVersion);
        iHead += strlib::extractStr(&m_szResponseStr[iHead],' ',m_szStatusCode);
        iHead += strlib::extractStr(&m_szResponseStr[iHead],'\r',m_szStatusText) +1 ;   //plus one to remove the new line

        //Header items
        while(m_szResponseStr[iHead])
        {
            iHead += strlib::extractStr(&m_szResponseStr[iHead],':',m_szHeaderName[m_iHeaderItemCount]) +1; //plus one to remove the space
            iHead += strlib::extractStr(&m_szResponseStr[iHead],'\r',m_szHeaderData[m_iHeaderItemCount]) +1; //plus one to remove the new line
            m_iHeaderItemCount++;
            if(m_szResponseStr[iHead] == '\r' && m_szResponseStr[iHead+1] == '\n')
            {
                //End of header partition found
                iHead += 2;
                break;
            }
        }

        //Now check if the header contains Content-Length - item
        for(int i = 0; i < m_iHeaderItemCount;i++)
        {
            if(m_szHeaderName[i].compare("Content-Length") == 0)
            {
                m_iContentLen = atoi(m_szHeaderData[i].c_str());
                m_szContent = m_szResponseStr[iHead];
                break;
            }

        }
    }

    else
    {
        m_szContent = &m_szResponseStr[iHead];
    }



    //Content

}

const char * HTTPResponse::version()
{
    return m_szVersion.c_str();
}

const char* HTTPResponse::statusCode()
{
    return m_szStatusCode.c_str();
}

const char * HTTPResponse::statusText()
{
    return m_szStatusText.c_str();
}

const char * HTTPResponse::content()
{
    return m_szContent.c_str();
}

int HTTPResponse::headerItemCount()
{
    return m_iHeaderItemCount;
}

bool HTTPResponse::getHeaderItem(const int item, std::string & itemName,  std::string & itemData)
{
    if(item < m_iHeaderItemCount)
        return false;

    itemName = m_szHeaderName[item];
    itemData = m_szHeaderData[item];
    return true;
}

const char * HTTPResponse::headerItemName(const int item)
{
    if(item > m_iHeaderItemCount)
        return NULL;
    return m_szHeaderName[item].c_str();
}

const char * HTTPResponse::headerItemData(const int item)
{
    if(item > m_iHeaderItemCount)
        return NULL;
    return m_szHeaderData[item].c_str();
}

void HTTPResponse::Clear()
{
    m_szResponseStr.clear();
    m_szVersion.clear();
    m_szStatusCode.clear();
    m_szStatusText.clear();
    m_szContent.clear();
    for(int i = 0; i < HTTP_HEADER_MAX_COUNT;i++)
    {
       m_szHeaderData[i].clear();
       m_szHeaderName[i].clear();
    }
    m_iContentLen = 0;
    m_iHeaderItemCount = 0;
}


HTTPClient::HTTPClient()
{
    m_pSocket = NULL;
    m_pSocket = new TCPSocket();

    m_bNewErrMsg = false;
    memset(m_szLastError,0,sizeof(m_szLastError));


}

HTTPClient::~HTTPClient()
{
    if(NULL != m_pSocket)
        delete m_pSocket;


}

bool HTTPClient::TestConnection(const char *hostName)
{
    if(false == m_pSocket->Connect(hostName,80))
    {
        sprintf(m_szLastError,"Connection test failed. %s",m_pSocket->GetLastError());
        m_bNewErrMsg = true;
        return false;
    }

    m_pSocket->Disconnect();
    return true;
}

HTTPRequest *HTTPClient::httpRequest()
{
    return &m_httpRequest;
}

HTTPResponse *HTTPClient::httpResponse()
{
    return &m_httpResponse;
}

bool HTTPClient::SendRequest(const char * host)
{
    const char* reqStr = m_httpRequest.requestString();

    m_httpResponse.Clear();

    if(false == m_pSocket->Connect(host,80))
    {

        m_bNewErrMsg = true;
        strcpy(m_szLastError, "Connecting socket failed.");
        strcat(m_szLastError,m_pSocket->GetLastError());
        return false;

    }

    int len = strlen(reqStr)+1;
    if(len != (m_pSocket->Write(reqStr,len)))
    {

        m_bNewErrMsg = true;
        strcpy(m_szLastError, "Write to socket failed.");
        strcat(m_szLastError,m_pSocket->GetLastError());
        return false;

    }

    //printf("\n\nRequest:\n\n%s\n\n",m_httpRequest.requestString());


    char * buf = new char[HTTP_HEADER_MAX_SIZE+HTTP_CONTENT_MAX_SIZE];

    if( -1 == (m_pSocket->Read(buf,HTTP_HEADER_MAX_SIZE+HTTP_CONTENT_MAX_SIZE)))
    {
        m_bNewErrMsg = true;
        strcpy(m_szLastError, "Readding from socket failed.");
        strcat(m_szLastError,m_pSocket->GetLastError());
        return false;
    }

    m_httpResponse.setHttpResponseStr(buf);
    delete[] buf;

    //printf("\n\nResponse:%s",httpResponse()->getHttpResponseStr());
    m_httpResponse.parseResponseStr();
    m_pSocket->Disconnect();

    httpRequest()->Clear();

    return true;
}


const char * HTTPClient::GetLastError()
{
    if (m_bNewErrMsg)
    {
        return m_szLastError;

    }

    else
    {
        return NULL;
    }

}
