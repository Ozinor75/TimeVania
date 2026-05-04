using System;
using UnityEngine;

public class CameraRoom : MonoBehaviour
{
    private Collider2D trigger;
    private CameraFollow cameraFollow;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            cameraFollow.ChangeCameraRoom(trigger);
        }
    }

    void Start()
    {
        cameraFollow = FindFirstObjectByType<CameraFollow>();
        trigger = GetComponent<Collider2D>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
