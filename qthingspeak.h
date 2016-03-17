#ifndef QTHINGSPEAK_H
#define QTHINGSPEAK_H
#include <QObject>
#include <QThread>
#include "thingspeakclient.h"
#include <QString>

#define READ_INTERVAL_DEFAULT           5000  //msec
#define CHANNEL_ID "33914"


class Reader : public QObject
{
    friend class QThingSpeak;
    Q_OBJECT
public:

    explicit Reader(QObject * parent = 0);
    virtual ~Reader();
    void SetChannelId(const char * szChannelId);
    void SetReadApiKey(const char * szApiKey);
    void MarkFieldForReading(int iField, bool bEnable);

public slots:
    void on_start();
    void on_stop();

private:
    bool m_bFieldMarkedForReading[THINGSPEAK_MAX_FIELDS];
    int m_iReadInterval;
    bool m_bIsRunning;
    bool m_bShutDownRequested;
    QString m_sApiKey;
    QString m_sChannelId;
    ThingSpeakClient * m_pThingSpeakClient;

    void threadLoop();

signals:
    void stopped();
    void fieldDataReady(int iField, const char * data);
    void channelDataReady(TS_CHANNEL_LAST channel);
};

class QThingSpeak : public QObject
{
    Q_OBJECT
public:
    explicit QThingSpeak(QObject * parent = 0);

    virtual ~QThingSpeak();

public slots:
    void on_channelDataReady(TS_CHANNEL_LAST channel);
    void on_fieldDataReady(int iField, const char * data);

private:

    QThread * m_pWorkerThread;
    Reader * m_pReader;

signals:

    void startReader();
    void stopReader();

    void fieldDataAvailable(int iField, const char * data);
    void channelDataAvailable(TS_CHANNEL_LAST channelData);


};

#endif // QTHINGSPEAK_H
