using System;
using UnityEngine;

public class PowerUp : MonoBehaviour
{
    private BatteryAffector _batteryAffector;
    private PlayerSound playerSound;
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            _batteryAffector.ChangeTime();
            playerSound.Reload();
            Destroy(gameObject);
        }
    }

    void Start()
    {
        _batteryAffector = GetComponent<BatteryAffector>();
        playerSound = FindObjectOfType<PlayerSound>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
