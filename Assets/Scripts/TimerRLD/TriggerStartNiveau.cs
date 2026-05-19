using System;
using UnityEngine;

public class TriggerStartNiveau : MonoBehaviour
{
    public TimerChallenge timerScript;

    private void OnTriggerEnter2D(Collider2D other)
    {
        timerScript.StartTimer();
    }
}
