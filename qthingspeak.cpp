#include "qthingspeak.h"

Reader::Reader(QObject *parent) : QObject (parent)
{
    m_pThingSpeakClient = new ThingSpeakClient();

    m_iReadInterval = READ_INTERVAL_DEFAULT;
    m_bIsRunning= false;
    m_bShutDownRequested = false;

    for(int i = 0; i < THINGSPEAK_MAX_FIELDS; i++)
    {
        m_bFieldMarkedForReading[i] = false;
    }
}

Reader::~Reader()
{
    delete m_pThingSpeakClient;
}

void Reader::SetChannelId(const char *szChannelId)
{
    m_sChannelId = szChannelId;
}
void Reader::SetReadApiKey(const char *szApiKey)
{
    m_sApiKey = szApiKey;
}

void Reader::MarkFieldForReading(int iField, bool bEnable)
{
    if(iField == 0 || iField > THINGSPEAK_MAX_FIELDS)
        return;

    m_bFieldMarkedForReading[iField-1] = bEnable;
}

void Reader::on_start()
{
    if(false == m_bIsRunning)
        threadLoop();
}

void Reader::on_stop()
{
    m_bShutDownRequested = true;
}
void Reader::threadLoop()
{
    TS_CHANNEL_LAST channel;
    m_bIsRunning = true;
    while (false == m_bShutDownRequested)
    {
        if(true == m_pThingSpeakClient->readWholeChannel(channel,m_sChannelId.toStdString().c_str(),m_sApiKey.toStdString().c_str()))
        {
            emit(channelDataReady(channel));
            for(int i = 0; i < THINGSPEAK_MAX_FIELDS; i++)
            {
                if(true == m_bFieldMarkedForReading[i])
                {
                    emit(fieldDataReady(i+1,channel.StringFieldData(i+1)));
                }
            }
        }
        usleep(READ_INTERVAL_DEFAULT*1000);
    }
}

QThingSpeak::QThingSpeak(QObject *parent) : QObject(parent)
{
    m_pReader = new Reader();
    m_pWorkerThread = new QThread();

    m_pReader->moveToThread(m_pWorkerThread);

    connect(m_pWorkerThread, &QThread::finished, m_pReader, &QObject::deleteLater);

    connect(this, &QThingSpeak::startReader, m_pReader, &Reader::on_start);
    connect(this, &QThingSpeak::stopReader, m_pReader, &Reader::on_stop);

    connect(m_pReader, &Reader::channelDataReady, this, &QThingSpeak::on_channelDataReady);
    connect(m_pReader, &Reader::fieldDataReady, this, &QThingSpeak::on_fieldDataReady);

    m_pReader->SetChannelId(CHANNEL_ID);
    m_pReader->SetReadApiKey("PUDY4RBY92KHNKTI");
    /*
    m_pReader->MarkFieldForReading(1,true);
    m_pReader->MarkFieldForReading(2,true);
    m_pReader->MarkFieldForReading(3,true);

    m_pReader->MarkFieldForReading(4,true);
    m_pReader->MarkFieldForReading(5,true);
    m_pReader->MarkFieldForReading(6,true);
    */

    m_pWorkerThread->start();

    emit(startReader());

}

QThingSpeak::~QThingSpeak()
{
    emit(stopReader());
    m_pWorkerThread->quit();

    m_pWorkerThread->wait(1000);

    delete m_pWorkerThread;
    delete m_pReader;
}

void QThingSpeak::on_channelDataReady(TS_CHANNEL_LAST channel)
{
    emit(channelDataAvailable(channel));
}

void QThingSpeak::on_fieldDataReady(int iField, const char *data)
{
    emit(fieldDataAvailable(iField,data));
}

