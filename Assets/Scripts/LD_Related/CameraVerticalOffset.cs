using System;
using Unity.Cinemachine;
using UnityEngine;

public class CameraVerticalOffset : MonoBehaviour
{
    private CameraFollow cameraFollow;
    void Start()
    {
        cameraFollow = FindFirstObjectByType<CameraFollow>();
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            cameraFollow.ChangeVerticalOffset(cameraFollow.offsetY);
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        cameraFollow.CancelVerticalOffset();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
