using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Serialization;

public class ME_Hook : MonoBehaviour
{
    public GlobalTime manager;
    public PlayerController player;
    public Transform hook;
    public LineRenderer hookLine;
    private Rigidbody2D rb;
    
    public float projectionSpeed;
    public float retractionSpeed;
    public float maxDist;

    public bool isHooked;
    
    public float delta;
    public float t;

    public bool UseRightStick;
    
    Vector3[] trailPos = new Vector3[2];

    private void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }

    public void FixedUpdate()
    {
        if (isHooked)
        {
            hookLine.enabled = true;
            DrawTrail();
        }
        
        float delta2 = Vector2.Distance(rb.position, hook.position);
        if (delta2 > maxDist)
            BreakHook();
    }

    public void chooseProjectOrRetract()
    {
        if (!isHooked)
            ProjectHook();
        else
            RetractHook();
    }
    
    public void ProjectHook()
    {
        Vector2 stickDirection;
        
        if (UseRightStick)
            stickDirection = player.hookStickDirection;
        else
            stickDirection = new Vector2(player.movementLeftRight, player.movementUpDown);
        
        hook.position = rb.position;
        
        if (stickDirection != Vector2.zero)
        {
            RaycastHit2D hit = Physics2D.Raycast(rb.position, stickDirection.normalized, maxDist);
            if (hit && hit.collider.CompareTag("Ground"))
            {
                StopAllCoroutines();
                StartCoroutine(HookProjection(hit.point, false));
            }

            else
            {
                StopAllCoroutines();
                StartCoroutine(HookProjection(rb.position + stickDirection.normalized * maxDist, true));
            }
        }
    }

    public void RetractHook()
    {
        if (delta <= maxDist)
        {
            StopAllCoroutines();
            StartCoroutine(HookRetraction());
        }

        else
        {
            BreakHook();
        }
    }

    public void DrawTrail()
    {
        trailPos[0] = rb.position;
        trailPos[1] = hook.position;
        hookLine.SetPositions(trailPos);
    }

    public IEnumerator HookProjection(Vector2 hitPos, bool isFake)
    {
        t = 0f;
        delta = Vector2.Distance(hook.position, hitPos);
        hookLine.enabled = true;
        
        Debug.Log("Starting Projection");
        while (delta >= 0.05f)
        {
            t = (Time.deltaTime * manager.active) * projectionSpeed;
            delta = Vector2.Distance(hook.position, hitPos);
            
            hook.position = Vector2.MoveTowards(hook.position, hitPos, t);
            DrawTrail();
            
            yield return null;
        }
        
        if (delta <= 0.05f)
        {
            if (!isFake)
            {
                isHooked = true;
                StartCoroutine(HookRetraction());
                Debug.Log("Hook Hooked");
                
                yield break;
            }
            
            else StartCoroutine(FailedRetraction());
            
            yield break;
        }
    }

    public IEnumerator FailedRetraction()
    {
        t = 0f;
        delta = Vector2.Distance(hook.position, rb.position);
        hookLine.enabled = true;
        
        Debug.Log("Starting Failed Retraction");
        while (delta >= 0.05f)
        {
            t = (Time.deltaTime * manager.active) * retractionSpeed;
            delta = Vector2.Distance(hook.position, rb.position);
            
            hook.position = Vector2.MoveTowards(hook.position, rb.position, t);
            DrawTrail();
            
            yield return null;
        }
        
        if (delta <= 0.05f)
        {
            isHooked = false;
            Debug.Log("Hook Failed");
            yield break;
        }
    }

    public IEnumerator HookRetraction()
    {
        t = 0f;
        delta = Vector2.Distance(rb.position, hook.position);
        rb.linearVelocity = Vector2.zero;
        rb.gravityScale = 0f;

        player.CanMove = false;
        // player.isJumping = true;
        
        Debug.Log("Starting Retraction");
        
        while (delta > 1f)
        {
            t = (Time.deltaTime * manager.active) * retractionSpeed;
            delta = Vector2.Distance(rb.position, hook.position);
            
            rb.position = Vector2.MoveTowards(rb.position, hook.position, t);
            // rb.linearVelocity = Vector2.MoveTowards(rb.position, hook.position, t);
            
            DrawTrail();
            yield return null;
        }
        
        if (delta <= 1f)
        {
            isHooked = false;
            BreakHook();
            Debug.Log("Hook Retracted");
            yield break;
        }
    }

    public void BreakHook()
    {
        StopAllCoroutines();
        rb.gravityScale = 1f;
        isHooked = false;

        // player.CanMove = true;
        // player.isJumping = false;
        
        trailPos[0] = Vector3.zero;
        trailPos[1] = Vector3.zero;
        hookLine.SetPositions(trailPos);
        hookLine.enabled = false;
    }
}
