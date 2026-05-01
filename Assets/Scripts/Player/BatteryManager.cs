using System;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class BatteryManager : MonoBehaviour
{
    private PlayerTimer playerTimer;
    private GlobalTime globalTime;
    private BatterySound batterySound;
    private Color batteryColor;
    
    public Material gaugeMat;

    private float r;
    private float s;

    public Color normalBaseColor;
    public Color normalPulseColor;
    public Color superchargedBaseColor;
    public Color superchargedPulseColor;
    private bool overclock;
    
    void Start()
    {
        playerTimer = FindFirstObjectByType<PlayerTimer>();
        globalTime = FindFirstObjectByType<GlobalTime>();
        batterySound = GetComponent<BatterySound>();

        r = 1;
        gaugeMat.SetColor("_BaseColor", normalBaseColor);
        gaugeMat.SetColor("_PulseColor", normalPulseColor);
        overclock = false;
    }

    private void Update()
    {
        EmptyBattery();
    }

    public void EmptyBattery()
    {
        if (playerTimer.t <= playerTimer.timer + 0.5)
        {
            r = playerTimer.t / playerTimer.timer;
            
            if (overclock)
            {
                gaugeMat.SetColor("_BaseColor", normalBaseColor);
                gaugeMat.SetColor("_PulseColor", normalPulseColor);
                overclock = false;
            }
                
        }

        else
        {
            r = playerTimer.t / playerTimer.t;

            if (!overclock)
            {
                gaugeMat.SetColor("_BaseColor", superchargedBaseColor);
                gaugeMat.SetColor("_PulseColor", superchargedPulseColor);
                overclock = true;
            }
            
        }
        
        s = globalTime.active;
        gaugeMat.SetFloat("_gaugeSpeed", s);
        gaugeMat.SetFloat("_gaugeValue", r);
    }
    
}
