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
    public float startOffset;
    [HideInInspector]public float t;
    private float r;
    public bool canMove = false;

    [Header("Time")]
    public GlobalTime manager;

    private void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();
        
        curve.postWrapMode = WrapMode.PingPong;
        ResetPos();
    }

    public void ResetPos()
    {
        canMove = false;
        t = startOffset;
        r = t / duration;
        movable.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));
    }

    void Update()
    {
        if (canMove)
        {
            t += Time.deltaTime  * manager.active;
            t %= duration * 2;
            r = t / duration;
        
            movable.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));
        }
    }
}
