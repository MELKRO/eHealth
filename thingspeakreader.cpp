#include "thingspeakreader.h"

ThingSpeakReader::ThingSpeakReader(QObject *parent) : QObject(parent)
{
    m_pQTS =  new QThingSpeak();
    connect(m_pQTS, &QThingSpeak::channelDataAvailable, this, &ThingSpeakReader::on_channelDataAvailable);
}

ThingSpeakReader::~ThingSpeakReader()
{
    delete m_pQTS;
}

void ThingSpeakReader::on_channelDataAvailable(TS_CHANNEL_LAST channel)
{
    emit(sendToQml(channel.IntFieldData(1),channel.IntFieldData(2),channel.IntFieldData(3)
                   ,channel.IntFieldData(4),channel.IntFieldData(5),channel.IntFieldData(6)
                   ,channel.IntFieldData(7),channel.IntFieldData(8)));
}

