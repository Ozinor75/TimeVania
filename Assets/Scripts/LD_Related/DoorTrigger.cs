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
    private float d;
    private float t;
    private float r;
    private bool isOpening = false;
    private bool isUsable = true;

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
        yield return new WaitForSecondsRealtime(1f);
        d = 1f;
        isOpening = true;
        while (r <= 1)
        {
            yield return null;
        }
        yield return new WaitForSecondsRealtime(0.5f);
        t = startOffset;
        current = movable.position;
        currentDistance = Vector3.Distance(movable.position, start.position);
        ratio = Vector3.Distance(movable.position, start.position) / totalDistance;
        r = 0;
        d = duration;
        isOpening = false;
        yield return new WaitForSecondsRealtime(0.7f);
        cameraFollow.toFollow = playerController.GetComponent<Transform>();
        playerController.CanMove = true;
        yield return new WaitForSecondsRealtime(1f);
        cameraFollow.maxDistance = 5f;
        while (r <= 1)
        {
            yield return null;
        }
        isUsable = true;
    }

    public void OpenDoor()
    {
        if (isUsable)
        {
            isUsable = false;
            buttonUI.SetActive(false);
            r = 0;
            t = startOffset;
            current = movable.position;
            currentDistance = Vector3.Distance(movable.position, end.position);
            ratio = Vector3.Distance(movable.position, end.position) / totalDistance;
            StartCoroutine(Cinematic());
        }
    }
    private void OnTriggerEnter2D(Collider2D other)
    {
        playerController.doorTrigger = transform;
        if (isUsable)
        {
            buttonUI.SetActive(true);
        }
    }
    private void OnTriggerExit2D(Collider2D other)
    {
        buttonUI.SetActive(false);
        playerController.doorTrigger = null;
    }

    private void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();
        cameraFollow = FindFirstObjectByType<CameraFollow>();
        playerController = FindFirstObjectByType<PlayerController>();
        t = startOffset;
        d = duration;
        current = start.position;
        totalDistance =  Vector3.Distance(start.position, end.position);
        
    }

    void Update()
    {
        if (isOpening)
        {
            t += Time.deltaTime  * manager.active;
            r = (t / (d * ratio));
        
            movable.position = Vector3.Lerp(current, end.position, curve.Evaluate(r));
        }
        else
        {
            if (current != start.position)
            {
                // Debug.Log("RATIO = " + ratio);
                t += Time.deltaTime  * manager.active;
                r = (t / (d * ratio));
                movable.position = Vector3.Lerp(current, start.position, curve.Evaluate(r));
            }
        }
    }
}
