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
    
    [Header("Distance Limits")]
    public float maxDistance = 10f;

    [Header("Vertical & Depth Offsets")]
    public float depthOffset;
    public float currentDepthOffset;
    public float heightOffset;
    public float offsetY;
    private float VerticalOffset = 0f;

    [Header("Vertical Smoothing")]
    public float smoothTimeEnter = 0.5f;
    public float smoothTimeExit = 0.15f;
    private float currentSmoothTime = 0.15f;

    private float targetVerticalOffset = 0f;
    private float verticalOffsetVelocity = 0f;
    

    private PlayerController playerController;
    
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
        playerController = FindAnyObjectByType<PlayerController>();
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

        if (playerControls.Player.Direction.ReadValue<Vector2>().x > 0.1 && !playerController.isCharging && playerController.CanMove)
            realOffset = -offset;
        else if (playerControls.Player.Direction.ReadValue<Vector2>().x < -0.1 && !playerController.isCharging && playerController.CanMove)
            realOffset = offset;
        else if (playerController.isCharging || (playerControls.Player.Direction.ReadValue<Vector2>().x < 0.1 && playerControls.Player.Direction.ReadValue<Vector2>().x > -0.1) || !playerController.CanMove)
            realOffset = 0f;

        float newX = Mathf.SmoothDamp(targetPos.x, toFollow.position.x + realOffset, ref realVelocity.x, smoothTimeX);
        targetPos = new Vector3(newX, toFollow.position.y, 0f);
        VerticalOffset = Mathf.SmoothDamp(VerticalOffset, targetVerticalOffset, ref verticalOffsetVelocity, currentSmoothTime);
        
        Vector3 currentCamPos = transform.position;
        Vector3 desiredPos = new Vector3(targetPos.x, targetPos.y + heightOffset + VerticalOffset, -currentDepthOffset);
        Vector3 smoothedPos = Vector3.Lerp(currentCamPos, desiredPos, followTime * Time.deltaTime);
    
        Vector2 focusCenter = new Vector2(toFollow.position.x, toFollow.position.y + heightOffset + VerticalOffset);
        Vector2 distanceVector = new Vector2(smoothedPos.x, smoothedPos.y) - focusCenter;
        Vector2 clampedDistance = Vector2.ClampMagnitude(distanceVector, maxDistance);
    
        transform.position = new Vector3(focusCenter.x + clampedDistance.x, focusCenter.y + clampedDistance.y, -currentDepthOffset);
    }

    public void ChangeVerticalOffset(float offset)
    {
        targetVerticalOffset = offset;
        currentSmoothTime = smoothTimeEnter;
    }

    public void CancelVerticalOffset()
    {
        targetVerticalOffset = 0f;
        currentSmoothTime = smoothTimeExit;
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