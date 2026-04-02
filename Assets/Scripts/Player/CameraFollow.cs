using System;
using UnityEngine;
using UnityEngine.Serialization;

public class CameraFollow : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public Transform toFollow;
    private Camera cam;
    
    public float followTime;
    public float depthOffset;
    public float currentDepthOffset;
    public float heightOffset;
    
    private void Start()
    {
        toFollow = GameObject.FindGameObjectWithTag("Player").transform;
        currentDepthOffset = depthOffset;
        cam = GetComponent<Camera>();
    }
    
    void FixedUpdate()
    {
        Vector3 self2Dpos = new Vector3(transform.position.x, transform.position.y + heightOffset, - currentDepthOffset);
        Vector3 other2Dpos = new Vector3(toFollow.transform.position.x, toFollow.transform.position.y + heightOffset, - currentDepthOffset);
        transform.position = Vector3.Lerp(self2Dpos,
            other2Dpos, followTime * Time.fixedDeltaTime);
    }

    public void ChangeMode(Transform go, float depth)
    {
        toFollow = go;
        currentDepthOffset = depth;
    }
    
}
