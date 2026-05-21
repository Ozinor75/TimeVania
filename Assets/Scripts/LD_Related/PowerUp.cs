using System;
using UnityEngine;

public class PowerUp : MonoBehaviour
{
    private BatteryAffector _batteryAffector;
    private PlayerSound playerSound;
    private PlayerFeedback playerFeedback;
    void Start()
    {
        _batteryAffector = GetComponent<BatteryAffector>();
        playerSound = FindFirstObjectByType<PlayerSound>();
        playerFeedback = FindFirstObjectByType<PlayerFeedback>();
    }
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            playerSound.Reload();
            playerFeedback.InvokeEvent(playerFeedback.powerUp);
            _batteryAffector.ChangeTime();
            Destroy(gameObject);
        }
    }
}
