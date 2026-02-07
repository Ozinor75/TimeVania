using UnityEngine;

public class TimeChanger : MonoBehaviour
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
        switch (isPositive)
        {
            case true:
                playerTimer.t += time;
                break;
            case false:
                playerTimer.t -= time;
                break;
        }
    }
}

