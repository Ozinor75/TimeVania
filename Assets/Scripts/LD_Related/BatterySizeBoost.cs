using System;
using UnityEngine;

public class BatterySizeBoost : MonoBehaviour
{
    private PlayerSound playerSound;
    private PlayerFeedback playerFeedback;
    private PlayerController playerController;
    private PlayerTimer playerTimer;
    private BatteryManager batteryManager;
    
    public GameObject buttonUI;
    private bool onTrigger;
    public bool isUsed;
    
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
        if (!isUsed)
        {
            batteryManager.activeLevel++;
            playerTimer.batterySizeBoost++;
            isUsed = true;
            SaveSystem.Save();
            playerTimer.maxTimer +=
                (((playerTimer.batteryBoostValue / 100) * playerTimer.maxTimer) * playerTimer.batterySizeBoost);
            playerTimer.timer = playerTimer.maxTimer;
            playerTimer.t = playerTimer.timer;
            batteryManager.UpdateBattery();
            playerController.boostTrigger = null;
            buttonUI.SetActive(false);
        }
    }
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player") && !isUsed)
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
