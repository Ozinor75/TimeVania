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
            cameraFollow.ChangeVerticalOffset(cameraFollow.VerticalOffset);
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        cameraFollow.ChangeVerticalOffset(0f);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
