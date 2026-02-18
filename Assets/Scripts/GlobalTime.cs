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
    
    void Start()
    {
        worldTime = WorldTime.TWO;
    }
}
