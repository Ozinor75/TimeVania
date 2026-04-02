using UnityEngine;

public class BatterySound : MonoBehaviour
{
    [Header("Prefabs")] 
    public AudioSource[] loseCharge;
    public AudioSource tickingTimer;
    
    private BatteryManager batteryManager;

    public void TickingTimer(bool on)
    {
        if (on)
        {
            if (!tickingTimer.isPlaying)
                tickingTimer.Play();
        }
        else
        {
            if (tickingTimer.isPlaying)
                tickingTimer.Stop();
        }
    }
    public void LoseCharge()
    {
        loseCharge[Random.Range(0, loseCharge.Length)].Play();
    }
    void Start()
    {
        batteryManager = GetComponent<BatteryManager>();
    }

    // Update is called once per frame
    void Update()
    {
    }
}
