using System;
using UnityEngine;

public class PowerUp : MonoBehaviour
{
    private TimeChanger timeChanger;
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            timeChanger.ChangeTime();
            Destroy(gameObject);
        }
    }

    void Start()
    {
        timeChanger = GetComponent<TimeChanger>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
