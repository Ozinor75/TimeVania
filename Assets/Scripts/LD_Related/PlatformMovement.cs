using System;
using UnityEngine;

public class PlatformMovement : MonoBehaviour
{
    [Header("Boundaries")]
    public Transform movable;
    public Transform start;
    public Transform end;
    public AnimationCurve curve;
    public float duration;
    private float t;
    private float r;

    [Header("Time")]
    public GlobalTime manager;

    private void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();
    }

    void Update()
    {
        t += Time.deltaTime  * manager.active;
        t %= duration * 2;
        r = t / duration;
        
        movable.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));
    }
}
