using System;
using UnityEngine;

public class TimeBubble : MonoBehaviour
{
    public float targetRadius = 3f;
    public float growthSpeed = 2f;
    void Start()
    {
    }

    void Update()
    {
        float currentRadius = transform.localScale.x / 2f;
        if (currentRadius < targetRadius)
        {
            float newRadius = currentRadius + growthSpeed * Time.deltaTime;
            if (newRadius > targetRadius)
                newRadius = targetRadius;
            float newDiameter = newRadius * 2f;
            transform.localScale = new Vector3(newDiameter, newDiameter, newDiameter);
        }
    }
}
