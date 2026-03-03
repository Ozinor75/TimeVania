using UnityEngine;

public class BatterySound : MonoBehaviour
{
    [Header("Prefabs")] 
    public AudioSource[] loseCharge;
    
    private BatteryManager batteryManager;

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
