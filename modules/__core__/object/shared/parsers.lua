object:register('job', function(input)
    local job = ensure(input, {})
    local job_grade = ensure(job.grade, {})

    return {
        name = ensure(job.name, 'unemployed'),
        label = ensure(job.label, 'Unemployed'),
        permissions = ensure(job.allowed, {}),
        grade_name = ensure(job_grade.name, 'unemployed'),
        grade_label = ensure(job_grade.label, 'unemployed'),
        grade_permissions = ensure(job_grade.permissions, {})
    }
end)