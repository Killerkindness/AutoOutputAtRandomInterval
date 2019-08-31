#SingleInstance, Force
#KeyHistory, 0
SetBatchLines, -1
ListLines, Off
SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
SetTitleMatchMode, 3 ; A window's title must exactly match WinTitle to be a match.
SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptName, , , , thisscriptname
#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling

counter := new SecondCounter

class SecondCounter {
    __New() {
        this.interval := 1000
        this.count := 0
        this.timer := ObjBindMethod(this, "Tick")
        this.debug := False
        this.randomSeconds := 0
        this.randomOutput := 0
        this.randomMin := 0
        this.randomMax := 20

        this.Info()
        this.SetRandomLimits()
    }
    Start() {
        timer := this.timer
        If (this.count == 0)
        {
            If (not this.debug)
            {
                TrayTip, Recursion Premium, % "Starting recursion", 0.5
            }
            Else
            {
                ToolTip % "Starting recursion"
                SetTimer, KillToolTip, 1000
            }
        }
        Else
        {
            If (not this.debug)
            {
                TrayTip, Recursion Premium, % "Recursion resumed", 0.5
            }
            Else
            {
                ToolTip % "Recursion resumed"
                SetTimer, KillToolTip, 1000
            }
        }
        ; Start the main timer
        SetTimer % timer, % this.interval
        
        ; Set the duration between outputs
        rand := 0
        Random, rand , this.randomMin, this.randomMax
        this.randomSeconds := rand
    }
    Stop(resetCount := False, useToolTip := True) {
        timer := this.timer
        SetTimer % timer, Off
        If (useToolTip)
        {
            If (not this.debug)
            {
                TrayTip, Recursion Premium, % "Recursion paused", 0.5
            }
            Else
            {
                ToolTip % "Recursion paused"
                SetTimer, KillToolTip, 1000
            }
        }
        If (resetCount)
        {
            this.count := 0
            this.randomSeconds := 0
        }
    }
    Tick() {
        ++this.count

        If(this.count >= this.randomSeconds)
        {
            this.SendRandomOutput()

            this.count := 0
            rand := 0
            Random, rand , this.randomMin, this.randomMax
            this.randomSeconds := rand
        }

        If (this.debug)
        {
            ToolTip % this.randomSeconds
            SetTimer, KillToolTip, 2000
        }
    }
    ResetCounter()
    {
        this.Stop(True, False)
        
        If (not this.debug)
        {
            TrayTip, Recursion Premium, % "Exiting Recursion", 0.5
        }
        Else
        {
            ToolTip % "Exiting Recursion s"
            SetTimer, KillToolTip, 1000
        }
    }
    ClearToolTip(waitDur)
    {
        Sleep %waitDur%
        ToolTip
    }
    ChangeDebugState()
    {
        this.debug := not this.debug
        ToolTip % "Debug: " this.debug
        SetTimer, KillToolTip, 1000
    }
    SendRandomOutput()
    {
        rand := 0
        Random, rand, 0, 4

        If(rand == 0)
        {
            Send, w
        }
        Else If(rand == 1)
        {
            Send, a
        }
        Else If(rand == 2)
        {
            Send, s
        }
        Else If(rand == 3)
        {
            Send, d
        }
        Else If(rand == 4)
        {
            Send, {Space}
        }
        Else
        {
            Send, {Escape}
        }
    }
    SetRandomLimits()
    {
        minSec := 0
        maxSec := 0
        InputBox, minSec, RandomSecondsMin, Minumum amount of seconds between outputs., , 360, 120
        InputBox, maxSec, RandomSecondsMax, Maximum amount of seconds between outputs., , 360, 120
        this.randomMin := minSec
        this.randomMax := maxSec
    }
    Info()
    {
        MsgBox , , Recursion Premium, OwO - This is designed to send random output at random intervals (you'll define those next) to hopefully keep you logged in and not stuck wasting time in nasty login queues. I'm not responsible if you get banned lul. GLHF <3 (P.S. Right click the green 'H' icon in the system tray for more options.), 1000
    }
}

Menu, Tray, Add
Menu, Tray, Add, Info, MenuInfo
Menu, Tray, Add, Start Recursion (Alt+Ctrl+Z) , MenuStartTicks
Menu, Tray, Add, Stop Recursion (Alt+Ctrl+X), MenuStopTicks
Menu, Tray, Add, Reset (Alt+Ctrl+C), MenuResetTicks
;Menu, Tray, Add, Debug, MenuDebugTicks
Menu, Tray, Add, Set Random Limits (Alt+Ctrl+V), MenuSetRandomLimits
return

MenuStartTicks:
    counter.Start()
Return

MenuStopTicks:
    counter.Stop()
Return

MenuResetTicks:
    counter.ResetCounter()
Return

MenuDebugTicks:
    counter.ChangeDebugState()
Return

MenuSetRandomLimits:
    counter.SetRandomLimits()
Return

MenuInfo:
    counter.Info()
Return

KillToolTip:
    SetTimer, KillToolTip, Off
    ToolTip
Return

!^z::
    counter.Start()
Return

!^x::
    counter.Stop()
Return

!^c::
    counter.ResetCounter()
Return

!^v::
    counter.SetRandomLimits()
Return