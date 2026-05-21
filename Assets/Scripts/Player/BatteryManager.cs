using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class BatteryManager : MonoBehaviour
{
    private PlayerTimer playerTimer;
    private GlobalTime globalTime;
    private BatterySound batterySound;
    private RectTransform selfRect;
    
    public Material gaugeMat;
    public Material caseMat;
    public Material backCaseMat;
    public int activeLevel;
    public int totalLevels;

    public int starLevel;

    public List<Color> caseColors = new List<Color>();
    private float r;
    
    void Start()
    {
        playerTimer = FindFirstObjectByType<PlayerTimer>();
        globalTime = FindFirstObjectByType<GlobalTime>();
        batterySound = GetComponent<BatterySound>();
        selfRect = GetComponent<RectTransform>();

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
        caseMat.SetFloat("_ActiveLevel", activeLevel);
        backCaseMat.SetFloat("_ActiveLevel", activeLevel);
        
        caseMat.SetColor("_BaseColor", caseColors[starLevel]);
        backCaseMat.SetColor("_BaseColor", caseColors[starLevel]);
    }
}
