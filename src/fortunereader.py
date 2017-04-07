#!/usr/bin/env python
# Fortune reader: A interface for reading fortune cookies.
# License: GPLv3+
# Author: Manuel Domínguez López
# Changelog:
# 201512200621: Se añaden marcos y barras de desplazamiento.
# 201512192230: Versión inicial.


import tkinter
import tkinter.ttk
import tkinter.messagebox
import subprocess
import os
import gettext

gettext.translation('fortunereader', localedir='locale').install()

fortune = []  # Temp database containing fortune cookies
saved = []  # Saved cookies
fontsize = 12
savefile = os.getenv("HOME") + '/fortunereader.cookies'


def loadlocaldb():
    try:
        with open(savefile, 'r') as loadsaved:
            text = loadsaved.read()

        for line in text.split('\n%\n'):
            saved.append(line)  # Do not line.strip() for match with original
    except FileNotFoundError:
        pass
    except PermissionError:
        bsave.config(command=printwarnperm)
    except IsADirectoryError:
        bsave.config(command=printwarndir)
    except Exception as e:
        bsave.config(command=printerror(e))


def printwarnperm(
        text=_('You have not permission to save cookies'),
        title=_('Warning')):
    tkinter.messagebox.showwarning(title + ': ', text)


def printwarndir(
    text=_('The database file is a directory. \
            You can not save cookies there.'),
            title=_('Warning')):
    tkinter.messagebox.showwarning(title + ': ', text)


def printerror(error):
    title = _('Error') + '(' + str(error.errno) + '):  ' + error.strerror
    text = _('An unexpected error has happened:') + '\n\n' + '(' + str(error.errno)
    + ')  ' + error.strerror + _('\n\nThe program will close.')
    tkinter.messagebox.showerror(title, text)
    window.destroy()
    exit()


def newcookie():
    global current
    cookie = subprocess.getoutput('fortune')
    fortune.append(cookie)
    index = len(fortune) - 1
    current = index
    printcookie()
    settitle(current)
    disablebuttons(fortune[current])  # Prevent repetition


def prevcookie():
    global current
    if current == 0:
        current = len(fortune) - 1
    else:
        current = current - 1
    printcookie(current)
    settitle(current)
    disablebuttons(fortune[current])


def nextcookie():
    global current
    if current == len(fortune) - 1:
        current = 0
    else:
        current = current + 1
    printcookie(current)
    settitle(current)
    disablebuttons(fortune[current])


def printcookie(index=-1):
    t1.delete('1.0', tkinter.END)  # Cleaning screen
    t1.insert(tkinter.CURRENT, fortune[index])


def savecookie():
    cookie = fortune[current]
    formatcookie = fortune[current] + '\n%\n'
    if cookie not in saved:
        with open(savefile, 'a') as mysavefile:
            mysavefile.write(formatcookie)
        saved.append(cookie)
        disablebuttons(cookie)
    else:
        print(_('Already saved'))


def settitle(index):
    title = _('Fortune:'), index + 1
    window.title(title)


def disablebuttons(cookie):
    # Save button:
    if cookie in saved:
        bsave.config(state=tkinter.DISABLED)
    else:
        bsave.config(state=tkinter.NORMAL)
    # Prev button:
    if len(fortune) == 1:
        bprev.config(state=tkinter.DISABLED)
        bnext.config(state=tkinter.DISABLED)
    else:
        bprev.config(state=tkinter.NORMAL)
        bnext.config(state=tkinter.NORMAL)


def center_window(win, width=629, height=269):
    # get screen width and height
    screen_width = win.winfo_screenwidth()
    screen_height = win.winfo_screenheight()

    # calculate position x and y coordinates
    x = (screen_width/2) - (width/2)
    y = (screen_height/2) - (height/2)
    win.geometry('%dx%d+%d+%d' % (width, height, x, y))

window = tkinter.Tk()
center_window(window)
window.resizable(0, 0)

frame1 = tkinter.ttk.Frame(window)
frame1['padding'] = (5, 10)
frame1.pack()

frame2 = tkinter.ttk.Frame(window)
frame2['padding'] = (5, 10)
frame2.pack(side=tkinter.LEFT)

frame3 = tkinter.ttk.Frame(window)
frame3['padding'] = (5, 10)
frame3.pack(side=tkinter.LEFT)

frame4 = tkinter.ttk.Frame(window)
frame4['padding'] = (50, 0)
frame4.pack(side=tkinter.LEFT)

t1 = tkinter.Text(
        frame1, width=60, height=10, font=('Sans', fontsize), wrap='word')
t1.pack(side=tkinter.LEFT)


scrollbar = tkinter.Scrollbar(frame1)
scrollbar.pack(side=tkinter.LEFT, fill=tkinter.Y)

scrollbar.config(command=t1.yview)
t1.config(yscrollcommand=scrollbar.set)

bnew = tkinter.Button(
        frame2, text=_('New cookie'),
        font=('Sans', fontsize), command=newcookie)
bnew.pack(side=tkinter.LEFT)
bprev = tkinter.Button(
        frame3, text=_('Previous'), font=('Sans', fontsize), command=prevcookie)
bprev.pack(side=tkinter.LEFT)
bnext = tkinter.Button(
        frame3, text=_('Next'), font=('Sans', fontsize), command=nextcookie)
bnext.pack(side=tkinter.LEFT)
bsave = tkinter.Button(
        frame4, text=_('Save'), font=('Sans', fontsize), command=savecookie)
bsave.pack(side=tkinter.LEFT)
bexit = tkinter.Button(
        frame4, text=_('Exit'), font=('Sans', fontsize), command=window.destroy)
bexit.pack(side=tkinter.LEFT)

loadlocaldb()
newcookie()
window.mainloop()
