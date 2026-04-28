using System;
using UnityEngine;
using UnityEngine.UI;

public class BatteryManager : MonoBehaviour
{
    // globaltime #send to shader
    // size x = lerp remaintime/totaltime #shader
    // color = lerp red -> green remaintime/totaltime #shader
    // si barres, int bars # send to shader
    
    private PlayerTimer playerTimer;
    private GlobalTime globalTime;
    private BatterySound batterySound;
    private Color batteryColor;
    
    public Material gaugeMat;

    private float r;
    private float s;

    public Color baseColor;
    public Color superchargedColor;
    private bool overclock;
    
    void Start()
    {
        playerTimer = FindFirstObjectByType<PlayerTimer>();
        globalTime = FindFirstObjectByType<GlobalTime>();
        batterySound = GetComponent<BatterySound>();

        r = 1;
        gaugeMat.SetColor("_MainColor", baseColor);
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
                gaugeMat.SetColor("_MainColor", baseColor);
                overclock = false;
            }
                
        }

        else
        {
            r = playerTimer.t / playerTimer.t;

            if (!overclock)
            {
                gaugeMat.SetColor("_MainColor", superchargedColor);
                overclock = true;
            }
            
        }
        
        s = globalTime.active;
        gaugeMat.SetFloat("_gaugeSpeed", s);
        gaugeMat.SetFloat("_gaugeValue", r);
    }
    
}
