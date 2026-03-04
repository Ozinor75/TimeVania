using System;
using UnityEngine;

public class PowerUp : MonoBehaviour
{
    private TimeChanger timeChanger;
    private PlayerSound playerSound;
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            timeChanger.ChangeTime();
            playerSound.Reload();
            Destroy(gameObject);
        }
    }

    void Start()
    {
        timeChanger = GetComponent<TimeChanger>();
        playerSound = FindObjectOfType<PlayerSound>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
