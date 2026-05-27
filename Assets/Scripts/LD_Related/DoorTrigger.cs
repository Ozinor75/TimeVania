using System;
using System.Collections;
using UnityEngine;

public class DoorTrigger : MonoBehaviour
{
    [Header("Boundaries")]
    public Transform movable;
    public Transform start;
    public Transform end;
    public Transform anchor;
    public Vector3 current;
    public AnimationCurve curve;
    public float duration;
    public float startOffset;
    private float t;
    private float r;
    private bool isOpening = false;

    [Header("References")]
    public GlobalTime manager;
    public GameObject buttonUI;
    private PlayerController playerController;
    private CameraFollow cameraFollow;

    [Header("Debug")]
    public float totalDistance;
    public float currentDistance;
    public float ratio;

    private IEnumerator Cinematic()
    {
        cameraFollow.maxDistance = 1000f;
        cameraFollow.toFollow = anchor;
        playerController.CanMove = false;
        yield return new WaitForSeconds(1f);
        isOpening = true;
        yield return new WaitForSeconds(1f);
        cameraFollow.toFollow = playerController.GetComponent<Transform>();
        playerController.doorTrigger = null;
        playerController.CanMove = true;
        yield return new WaitForSeconds(1f);
        cameraFollow.maxDistance = 5f;
    }

    public void OpenDoor()
    {
        t = startOffset;
        current = movable.position;
        currentDistance = Vector3.Distance(movable.position, end.position);
        ratio = Vector3.Distance(movable.position, end.position) / totalDistance;
        StartCoroutine(Cinematic());
    }
    private void OnTriggerEnter2D(Collider2D other)
    {
        playerController.doorTrigger = transform;
    }
    private void OnTriggerExit2D(Collider2D other)
    {
        playerController.doorTrigger = null;
        t = startOffset;
        current = movable.position;
        currentDistance = Vector3.Distance(movable.position, start.position);
        ratio = Vector3.Distance(movable.position, start.position) / totalDistance;
        isOpening = false;
    }

    private void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();
        cameraFollow = FindFirstObjectByType<CameraFollow>();
        playerController = FindFirstObjectByType<PlayerController>();
        t = startOffset;
        current = start.position;
        totalDistance =  Vector3.Distance(start.position, end.position);
        
    }

    void Update()
    {
        if (isOpening)
        {
            t += Time.deltaTime  * manager.active;
            r = (t / (duration * ratio));
        
            movable.position = Vector3.Lerp(current, end.position, curve.Evaluate(r));
        }
        else
        {
            if (current != start.position)
            {
                // Debug.Log("RATIO = " + ratio);
                t += Time.deltaTime  * manager.active;
                r = (t / (duration * ratio));
                movable.position = Vector3.Lerp(current, start.position, curve.Evaluate(r));
            }
                
        }
    }
}
