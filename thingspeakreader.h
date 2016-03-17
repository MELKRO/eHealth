#ifndef THINGSPEAKREADER_H
#define THINGSPEAKREADER_H

#include "thingspeakclient.h"
#include "qthingspeak.h"
#include <QObject>


class ThingSpeakReader : public QObject
{
    Q_OBJECT
public:
    //Constructor
    explicit ThingSpeakReader(QObject * parent = 0);
    //Destructor
    virtual ~ThingSpeakReader();

public slots:
    void on_channelDataAvailable(TS_CHANNEL_LAST channel);

signals:
    void sendToQml(int temp_keittio, int temp_ulko, int temp_pesuhuone, int hum_pesuhuone, int kast_pesuhuone, int valoisuus,int co2,int b);

private:
    QThingSpeak * m_pQTS;

};

#endif // THINGSPEAKREADER_H
