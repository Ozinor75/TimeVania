using System;
using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.Serialization;

public class CameraFollow : MonoBehaviour
{
    [Header("References")]
    public Transform toFollow;
    public CustomInputs playerControls;
    private CinemachineConfiner2D confiner;
    private Camera cam;

    [Header("General Dynamics")]
    public float followTime;
    public Vector3 targetPos;

    [Header("Look Ahead (X Axis)")]
    public float offset = 3f;
    public float smoothTimeX = 0.25f;
    private float realOffset = 0f;
    private Vector3 realVelocity = new Vector3(2, 0, 0);

    [Header("Vertical & Depth Offsets")]
    public float depthOffset;
    public float currentDepthOffset;
    public float heightOffset;
    public float offsetY;
    private float VerticalOffset = 0f;

    [Header("Distance Limits")]
    public float maxDistance = 10f; // La distance maximale autorisée

    private void OnEnable()
    {
        if (playerControls == null)
            playerControls = new CustomInputs();
        
        playerControls.Enable();
    }
    
    private void OnDisable()
    {
        playerControls.Disable();
    }

    private void Start()
    {
        currentDepthOffset = depthOffset;
        cam = GetComponent<Camera>();
        confiner = FindFirstObjectByType<CinemachineConfiner2D>();

        if (toFollow != null)
        {
            targetPos = toFollow.position;
        }
    }
    
    void LateUpdate()
    {
        if (toFollow == null) return;

        if (playerControls.Player.Direction.ReadValue<Vector2>().x > 0.1)
            realOffset = -offset;
        else if (playerControls.Player.Direction.ReadValue<Vector2>().x < -0.1)
            realOffset = offset;
        else
            realOffset = 0f;

        float newX = Mathf.SmoothDamp(targetPos.x, toFollow.position.x + realOffset, ref realVelocity.x, smoothTimeX);
        targetPos = new Vector3(newX, toFollow.position.y, 0f);

        Vector3 self2Dpos = new Vector3(transform.position.x, transform.position.y + heightOffset, -currentDepthOffset);
        Vector3 other2Dpos = new Vector3(targetPos.x, targetPos.y + heightOffset + VerticalOffset, -currentDepthOffset);
        Vector3 desiredCameraPos = Vector3.Lerp(self2Dpos, other2Dpos, followTime * Time.fixedDeltaTime);
        Vector2 focusCenter = new Vector2(toFollow.position.x, toFollow.position.y + heightOffset + VerticalOffset);
        Vector2 currentDistanceVector = new Vector2(desiredCameraPos.x, desiredCameraPos.y) - focusCenter;
        Vector2 clampedDistance = Vector2.ClampMagnitude(currentDistanceVector, maxDistance);

        transform.position = new Vector3(focusCenter.x + clampedDistance.x, focusCenter.y + clampedDistance.y, -currentDepthOffset);
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
        if (confiner != null)
            confiner.BoundingShape2D = trigger;
    }
}