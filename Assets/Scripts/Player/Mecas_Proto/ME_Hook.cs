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
    
    public float projectionSpeed;
    public float retractionSpeed;
    public float maxDist;

    public bool isHooked;
    
    public float delta;
    public float t;
    
    Vector3[] trailPos = new Vector3[2];


    public void Update()
    {
        // delta = Vector2.Distance(transform.position, hook.position);

        if (isHooked)
        {
            hookLine.enabled = true;
            DrawTrail();
            player.CanMove = false;
        }
            
        else hookLine.enabled = false;
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
        Vector2 test = new Vector2(player.movementLeftRight, player.movementUpDown);
        hook.position = player.transform.position;
        if (player.movement != Vector2.zero)
        {
            RaycastHit2D hit = Physics2D.Raycast(player.transform.position, test.normalized, maxDist);
            if (hit && hit.collider.CompareTag("Ground"))
            {
                StopAllCoroutines();
                StartCoroutine(HookProjection(hit.point));
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
            Debug.Log("TOO FAR");
        }
    }

    public void DrawTrail()
    {
        trailPos[0] = transform.position;
        trailPos[1] = hook.position;
        hookLine.SetPositions(trailPos);
    }

    public IEnumerator HookProjection(Vector2 hitPos)
    {
        t = 0f;
        delta = Vector2.Distance(hook.position, hitPos);
        player.CanMove = false;
        
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
            isHooked = true;
            Debug.Log("Hook Hooked");
            yield break;
        }
    }

    public IEnumerator HookRetraction()
    {
        t = 0f;
        delta = Vector2.Distance(transform.position, hook.position);
        player.CanMove = false;
        
        Debug.Log("Starting Retraction");
        while (delta >= 0.05f)
        {
            t = (Time.deltaTime * manager.active) * retractionSpeed;
            delta = Vector2.Distance(transform.position, hook.position);
            
            transform.position = Vector2.MoveTowards(transform.position, hook.position, t);
            DrawTrail();
            yield return null;
        }
        
        if (delta <= 0.05f)
        {
            isHooked = false;
            player.CanMove = true;
            Debug.Log("Hook Retracted");
            yield break;
        }
    }
}
