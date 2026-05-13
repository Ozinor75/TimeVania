using System;
using UnityEngine;

public class TriggerPlatform : MonoBehaviour
{
    public PlatformMovement platformScript;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!platformScript.canMove)
        {
            platformScript.t = platformScript.startOffset;
            platformScript.canMove = true;
        }
    }
}
