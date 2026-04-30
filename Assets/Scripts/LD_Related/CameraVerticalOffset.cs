using System;
using Unity.Cinemachine;
using UnityEngine;

public class CameraVerticalOffset : MonoBehaviour
{
    public float VerticalOffset = -2.8f;
        
    private CinemachinePositionComposer cinemachineCamera;
    void Start()
    {
        cinemachineCamera = FindFirstObjectByType<CinemachinePositionComposer>();
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            cinemachineCamera.TargetOffset.y = VerticalOffset;
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        cinemachineCamera.TargetOffset.y = 0f;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
