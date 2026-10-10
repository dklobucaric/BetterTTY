#include "TerminalBridge.h"

TerminalBridge::TerminalBridge(QObject *parent)
    : QObject(parent)
{
}

void TerminalBridge::sendInput(const QString &input)
{
    emit inputReceived(input);
}

void TerminalBridge::requestPaste()
{
    emit pasteRequested();
}

void TerminalBridge::requestCopy()
{
    emit copyRequested();
}

void TerminalBridge::requestTabSwitch(int direction)
{
    // Only the two supported navigation directions may leave the WebEngine.
    if (direction == -1 || direction == 1) {
        emit tabSwitchRequested(direction);
    }
}

void TerminalBridge::autoCopySelection(const QString &selection)
{
    if (!selection.isEmpty()) {
        emit autoCopyRequested(selection);
    }
}

void TerminalBridge::terminalReady()
{
    emit ready();
}

void TerminalBridge::terminalResized(int columns, int rows)
{
    emit resizeRequested(columns, rows);
}

void TerminalBridge::emitOutput(const QByteArray &output)
{
    if (output.isEmpty()) {
        return;
    }

    emit outputBytesReceived(QString::fromLatin1(output.toBase64()));
}

void TerminalBridge::emitStatus(const QString &status)
{
    emit statusChanged(status);
}

void TerminalBridge::emitError(const QString &error)
{
    emit errorReceived(error);
}
