using NUnit.Framework;
using System.Collections.Generic;
using UnityEngine;

public class PlatfromInitialize : MonoBehaviour
{
    public List<PlatformMovement> children = new List<PlatformMovement>();
    void Start()
    {
        for (int i = 0; i < transform.childCount; i++)
        {
            children.Add(transform.GetChild(i).GetComponent<PlatformMovement>());
        }
    }

    public void ResetChildPos()
    {
        foreach (PlatformMovement child in children)
        {
            child.ResetPos();
        }
    }
}
