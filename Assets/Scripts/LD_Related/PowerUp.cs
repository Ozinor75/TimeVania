using System;
using UnityEngine;

public class PowerUp : MonoBehaviour
{
    private BatteryAffector _batteryAffector;
    private PlayerSound playerSound;
    void Start()
    {
        _batteryAffector = GetComponent<BatteryAffector>();
        playerSound = FindObjectOfType<PlayerSound>();
    }
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            _batteryAffector.ChangeTime();
            Destroy(gameObject);
        }
    }
}
