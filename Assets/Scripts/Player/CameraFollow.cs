using System;
using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.Serialization;

public class CameraFollow : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public Transform toFollow;
    private Camera cam;
    // private CinemachinePositionComposer cinemachineCamera;
    private CinemachineConfiner2D confiner;
    
    public float followTime;
    public float depthOffset;
    public float currentDepthOffset;
    public float heightOffset;
    private float VerticalOffset = 0f;
    public float offsetY;
    private void Start()
    {
        currentDepthOffset = depthOffset;
        cam = GetComponent<Camera>();
        confiner = FindFirstObjectByType<CinemachineConfiner2D>();
    }
    
    void FixedUpdate()
    {
        Vector3 self2Dpos = new Vector3(transform.position.x, transform.position.y + heightOffset, - currentDepthOffset);
        Vector3 other2Dpos = new Vector3(toFollow.transform.position.x, toFollow.transform.position.y + heightOffset + VerticalOffset, - currentDepthOffset);
        transform.position = Vector3.Lerp(self2Dpos,
            other2Dpos, followTime * Time.fixedDeltaTime);
    }

    public void ChangeVerticalOffset(float offset)
    {
        VerticalOffset = offset;
    }

    public void CancelVerticalOffset()
    {
        VerticalOffset = 0;
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
