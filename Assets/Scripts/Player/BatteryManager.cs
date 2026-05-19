using System;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class BatteryManager : MonoBehaviour
{
    private PlayerTimer playerTimer;
    private GlobalTime globalTime;
    private BatterySound batterySound;
    
    public Material gaugeMat;
    public int activeLevel;
    public int totalLevels;

    private float r;
    
    void Start()
    {
        playerTimer = FindFirstObjectByType<PlayerTimer>();
        globalTime = FindFirstObjectByType<GlobalTime>();
        batterySound = GetComponent<BatterySound>();

        r = 1;
        UpdateBattery();
    }

    private void Update()
    {
        EmptyBattery();
    }

    public void EmptyBattery()
    {
        r = playerTimer.t / playerTimer.timer;
        gaugeMat.SetFloat("_gaugeValue", r);
    }

    public void UpdateBattery()
    {
        gaugeMat.SetFloat("_TotalLevel", totalLevels);
        gaugeMat.SetFloat("_ActiveLevel", activeLevel);
    }
}
