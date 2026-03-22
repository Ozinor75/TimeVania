using System;
using UnityEngine;
using UnityEngine.Events;

public class ChargingRoom : MonoBehaviour
{
    public UnityEvent ExitStation;
    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            Debug.Log("Exiting Station");
            ExitStation.Invoke();
        }
    }

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
