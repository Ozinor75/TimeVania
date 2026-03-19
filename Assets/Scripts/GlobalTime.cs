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
    
    public void MidWorldTime()
    {
        Debug.Log("WorldTime mid");
        worldTime =  WorldTime.TWO;
    }
    public void IncreaseWorldTime()
    {
        Debug.Log("WorldTime Increase");
        worldTime++;
    }
    
    public void DecreaseWorldTime()
    {
        worldTime--;
    }
    void Start()
    {
        worldTime = WorldTime.TWO;
    }
}
