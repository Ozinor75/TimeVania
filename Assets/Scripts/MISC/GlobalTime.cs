using System;
using UnityEngine;

public enum WorldTime
{
    ONE,
    TWO,
    THREE
}
public class GlobalTime : MonoBehaviour
{
    public WorldTime worldTime;
    public float speed;
    public float slow;
    public float basic;
    public float active;
    
    void Start()
    {
        active = basic;
        worldTime = WorldTime.TWO;
    }
    
    public void MidWorldTime()
    {
        Debug.Log("WorldTime mid");
        active = basic;
        worldTime =  WorldTime.TWO;
    }
    public void IncreaseWorldTime()
    {
        Debug.Log("WorldTime Increase");
        active = speed;
        worldTime =  WorldTime.THREE;
    }
    
    public void DecreaseWorldTime()
    {
        Debug.Log("WorldTime Decrease");
        active = slow;
        worldTime =  WorldTime.ONE;
    }
}
