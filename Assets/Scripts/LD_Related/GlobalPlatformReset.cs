using System;
using System.Collections.Generic;
using UnityEngine;

public class GlobalPlatformReset : MonoBehaviour
{
    private List<PlatformMovement> childList = new List<PlatformMovement>();

    private void Start()
    {
        for (int i = 0; i <= transform.childCount; i++)
            childList.Add(transform.GetChild(i).GetComponent<PlatformMovement>());
    }

    public void ResetAll()
    {
        foreach (PlatformMovement child in childList)
        {
            child.ResetMovement();
        }
    }
}
