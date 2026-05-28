using System;
using UnityEngine;

public class MovingAndDestroy : MonoBehaviour
{
    [Header("Movement")]
    public Transform movable;
    private float t;
    private float r;
    private WorldEvents worldEvents;

    [Header("Heritage")]
    public AnimationCurve curve;
    public float duration;
    public GlobalTime manager;
    public Transform start;
    public Transform end;
    
    [Header("DA")]
    public MeshRenderer LED;
    private Material LED_mat;
    
    public bool isOnPlatform = false;
    private void Start()
    {
        LED_mat = LED.materials[1];
        manager = FindFirstObjectByType<GlobalTime>();
        worldEvents = FindFirstObjectByType<WorldEvents>();
    }
    
    void Update()
    {
        t += Time.deltaTime  * manager.active;
        r = t / duration;
        
        movable.position = Vector3.Lerp(start.position, end.position, curve.Evaluate(r));

        if (movable.position == end.position)
        {
            if (isOnPlatform)
                worldEvents.platformDestroyed.Invoke();
            Destroy(gameObject);
        }
        LED_mat.SetFloat("_Ratio", r);
    }
}

