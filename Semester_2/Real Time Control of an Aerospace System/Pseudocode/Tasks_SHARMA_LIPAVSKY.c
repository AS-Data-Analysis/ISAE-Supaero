// Manage Request

Begin
OpenSocketServer
Repeat Indefinitely
	If Connected=True then
		rt_event_wait(request)
		Switch(request)
			'A': Abort Experiment:
				abort=1
				Response Acknowledge
			'D': Start Experiment:
				rt_sem_v(Start)
				Response Acknowledge
			'C': Read current sensor values:
				Response current sensor values + T
			'B': Read last sensor values block:
				If ExpFin=1 then
					Response Measure + F
				Else
					Response Measure + S
			'L': Experiment parameters:
				Update experiment parameters
				Response Acknowledge
			'error': Disconnect pressed
				Connected=False
				Disconnect
	End If
End Repeat
End


// Manage Duration and Periods (PA,PL)

Begin
	rt_task_set_periodic()
	Repeat Indefinitely
	rt_sem_p(start)
	rt_event_signal(Init)
	Abort=False
	Expfin=False
	While (t < duration and Abort=False and Connected)
		rt_task_wait_period(NULL)
		t=t+1
		If (t modulo LawPeriod)=0
			rt_event_signal(PL)
		If (t modulo AcquirePeriod)=0
			rt_event_signal(PA)
	End While
	ExpFin=True
	rt_event_signal(Finished)
	End Repeat
End


// Acquire Sensor Info & Manage Law and Setpoint

Begin
Repeat Indefinitely
	If rt_event_wait(PL) or rt_event_wait(Init)
		Read sensors
		If rt_event_wait(Init)
			InitializeExperiment
		End If
		If rt_event_wait(PL)
			CalculateSetPoint
			CalculateWheelCommand
		End If
		If rt_event_wait(finished)
			WheelCommand=0
	End If
	If rt_event_wait(PA)
		Read sensors
		Add sensor values to [Sensor Meas.]
	End If
End Repeat
End