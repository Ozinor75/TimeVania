using System;
using UnityEngine;

public class DoorTrigger : MonoBehaviour
{
    [Header("Boundaries")]
    public Transform movable;
    public Transform start;
    public Transform end;
    public Vector3 current;
    public AnimationCurve curve;
    public float duration;
    public float startOffset;
    private float t;
    private float r;
    private bool isOpening = false;

    [Header("Time")]
    public GlobalTime manager;

    [Header("Debug")]
    public float totalDistance;
    public float currentDistance;
    public float ratio;

    private void OnTriggerEnter2D(Collider2D other)
    {
        t = startOffset;
        current = movable.position;
        currentDistance = Vector3.Distance(movable.position, end.position);
        ratio = Vector3.Distance(movable.position, end.position) / totalDistance;
        if (!other.CompareTag("Wall") && !other.CompareTag("Ground"))
            isOpening = true;
    }
    private void OnTriggerExit2D(Collider2D other)
    {
        t = startOffset;
        current = movable.position;
        currentDistance = Vector3.Distance(movable.position, start.position);
        ratio = Vector3.Distance(movable.position, start.position) / totalDistance;
        isOpening = false;
    }

    private void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();
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
                Debug.Log("RATIO = " + ratio);
                t += Time.deltaTime  * manager.active;
                r = (t / (duration * ratio));
                movable.position = Vector3.Lerp(current, start.position, curve.Evaluate(r));
            }
                
        }
    }
}
