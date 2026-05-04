using System;
using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.Serialization;

public class CameraFollow : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public Transform toFollow;
    private Camera cam;
    private CinemachinePositionComposer cinemachineCamera;
    private CinemachineConfiner2D confiner;
    
    public float followTime;
    public float depthOffset;
    public float currentDepthOffset;
    public float heightOffset;
    public float HorizontalOffset;
    public float VerticalOffset;
    private void Start()
    {
        toFollow = GameObject.FindGameObjectWithTag("Player").transform;
        currentDepthOffset = depthOffset;
        cam = GetComponent<Camera>();
        cinemachineCamera = FindFirstObjectByType<CinemachinePositionComposer>();
        confiner = FindFirstObjectByType<CinemachineConfiner2D>();
        cinemachineCamera.TargetOffset.x = HorizontalOffset;
    }
    
    void FixedUpdate()
    {
        Vector3 self2Dpos = new Vector3(transform.position.x, transform.position.y + heightOffset, - currentDepthOffset);
        Vector3 other2Dpos = new Vector3(toFollow.transform.position.x, toFollow.transform.position.y + heightOffset, - currentDepthOffset);
        transform.position = Vector3.Lerp(self2Dpos,
            other2Dpos, followTime * Time.fixedDeltaTime);
    }

    public void ChangeVerticalOffset(float offset)
    {
        cinemachineCamera.TargetOffset.y = offset;
    }
    
    public void ChangeHorizontalOffset(float offset)
    {
        cinemachineCamera.TargetOffset.x = offset;
    }
    public void ChangeMode(Transform go, float depth)
    {
        toFollow = go;
        currentDepthOffset = depth;
    }

    public void ChangeCameraRoom(Collider2D trigger)
    {
        confiner.BoundingShape2D = trigger;
    }
    
}
