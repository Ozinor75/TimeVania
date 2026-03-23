using System;
using UnityEngine;
using UnityEngine.Serialization;

public class CameraFollow : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public GameObject toFollow;
    private Camera cam;
    
    public float followTime;
    public float depthOffset;
    public float currentDepthOffset;
    public float heightOffset;

    public void ChangeMode(GameObject rb, float depth)
    {
        toFollow = rb;
        currentDepthOffset = depth;
    }
    void FixedUpdate()
    {
        Vector3 self2Dpos = new Vector3(transform.position.x, transform.position.y + heightOffset, - currentDepthOffset);
        Vector3 other2Dpos = new Vector3(toFollow.transform.position.x, toFollow.transform.position.y + heightOffset, - currentDepthOffset);
        transform.position = Vector3.Lerp(self2Dpos,
            other2Dpos, followTime * Time.fixedDeltaTime);
    }

    private void Start()
    {
        toFollow = GameObject.FindGameObjectWithTag("Player");
        currentDepthOffset = depthOffset;
        cam = GetComponent<Camera>();
    }
}
