using System;
using UnityEngine;

public class PowerUp : MonoBehaviour
{
    private BatteryAffector _batteryAffector;
    private PlayerSound playerSound;
    private PlayerFeedback playerFeedback;
    private PlayerTimer playerTimer;
    void Start()
    {
        _batteryAffector = GetComponent<BatteryAffector>();
        playerSound = FindFirstObjectByType<PlayerSound>();
        playerFeedback = FindFirstObjectByType<PlayerFeedback>();
        playerTimer = FindFirstObjectByType<PlayerTimer>();
    }
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            playerSound.Reload();
            playerFeedback.InvokeEvent(playerFeedback.powerUp);
            _batteryAffector.time = _batteryAffector.time + (((playerTimer.powerUpAbsorptionBoostValue / 100) * _batteryAffector.time) * playerTimer.powerUpAbsorptionBoost);
            Debug.Log(_batteryAffector.time);
            _batteryAffector.ChangeTime();
            Destroy(gameObject);
        }
    }
}
