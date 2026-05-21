using System.Collections.Generic;
using UnityEngine;

public class GlobalThwompReset : MonoBehaviour
{
    private List<Thwomp> childList = new List<Thwomp>();

    private void Start()
    {
        for (int i = 0; i <= transform.childCount; i++)
            childList.Add(transform.GetChild(i).GetComponent<Thwomp>());
    }

    public void ResetAll()
    {
        foreach (Thwomp child in childList)
        {
            child.ResetMovement();
        }
    }
}
