using UnityEngine;

public class BatteryAffector : MonoBehaviour
{
    private PlayerTimer playerTimer; 
    
    public bool isPositive;
    public float time;
    void Start()
    {
        playerTimer = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerTimer>();
    }

    public void ChangeTime()
    {
        time = isPositive ? time : -time;
        playerTimer.t += time;
    }
}

