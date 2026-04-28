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
        // playerTimer = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerTimer>();
        playerTimer = FindFirstObjectByType<PlayerTimer>();
        globalTime = FindFirstObjectByType<GlobalTime>();
        batterySound = GetComponent<BatterySound>();
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
        // gaugeMat.SetFloat("_gaugeSpeed", s);    // si on vbeut le feedback dans le liquide, ce q'on ne veut pas forcément
        gaugeMat.SetFloat("_gaugeValue", r);    // si on vbeut le feedback dans le liquide, ce q'on ne veut pas forcément
    }
    
    // public void ShowBattery(int charge)
    // {
    //     r = playerTimer.t / playerTimer.timer;
    //     Debug.Log(r);
    //     
    //     int i;
    //     if (charge >= 7)
    //         batteryColor = Color.green;
    //     else if (charge >= 4)
    //         batteryColor = Color.yellow;
    //     else
    //         batteryColor = Color.red;
    //     for (i = 0; i < transform.childCount; i++)
    //     {
    //         if (i <  charge)
    //         {
    //             transform.GetChild(i).gameObject.SetActive(true);
    //             transform.GetChild(i).GetComponent<Image>().color = batteryColor;
    //         }
    //         else
    //         {
    //             if (transform.GetChild(i).gameObject.activeSelf)
    //             {
    //                 batterySound.LoseCharge();
    //                 transform.GetChild(i).gameObject.SetActive(false);
    //             }
    //         }
    //     }
    //
    //     if (playerTimer.t <= playerTimer.criticalTimer && playerTimer.t > 0f)
    //     {
    //         batterySound.TickingTimer(true);
    //     }
    //     else
    //     {
    //         batterySound.TickingTimer(false);
    //     }
    // }
}
