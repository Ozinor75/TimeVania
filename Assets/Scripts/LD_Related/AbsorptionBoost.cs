using System;
using UnityEngine;

public class AbsorptionBoost : MonoBehaviour
{
    private PlayerSound playerSound;
    private PlayerFeedback playerFeedback;
    private PlayerController playerController;
    private PlayerTimer playerTimer;
    private BatteryManager batteryManager;
    
    public GameObject buttonUI;
    private bool onTrigger;
    
    void Start()
    {
        playerController = FindFirstObjectByType<PlayerController>();
        playerSound = FindFirstObjectByType<PlayerSound>();
        playerTimer = FindFirstObjectByType<PlayerTimer>();
        playerFeedback = FindFirstObjectByType<PlayerFeedback>();
        batteryManager = FindFirstObjectByType<BatteryManager>();
    }

    public void MakeBoost()
    {
        batteryManager.starLevel++;
        playerTimer.powerUpAbsorptionBoost++;
        SaveSystem.Save();
        batteryManager.UpdateBattery();
        playerController.boostTrigger = null;
        Destroy(gameObject);
    }
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            onTrigger = true;
            playerController.boostTrigger = transform;
            buttonUI.SetActive(true);
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        onTrigger = false;
        playerController.boostTrigger = null;
        buttonUI.SetActive(false);
    }
}
