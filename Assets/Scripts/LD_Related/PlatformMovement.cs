using System;
using UnityEngine;

public class PlatformMovement : MonoBehaviour
{
    [Header("Boundaries")]
    public bool canMove;
    public Transform movable;
    public Transform start;
    public Transform end;
    public AnimationCurve curve;
    public float duration;
    public float startOffset;
    private float t;
    public float r;

    [Header("Time")]
    public GlobalTime manager;

    private void Start()
    {
        manager = FindFirstObjectByType<GlobalTime>();
        ResetMovement();
        
        curve.postWrapMode = WrapMode.PingPong;
        t = startOffset;
    }

    void Update()
    {
        if (canMove)
        {
            t += Time.deltaTime * manager.active;
            t %= duration * 2;
            r = t / duration;
        
            movable.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));
        }
    }
    
    public void ResetMovement()
    {
        r = 0;
        movable.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));
        canMove = false;
    }
}
